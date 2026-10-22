--スーパークリティカル
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate: add 1 card with a dice rolling effect from Deck to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--watch every dice roll; re-raise a custom event explicitly attributed to
	--whichever side's dice contained a 1, since EVENT_TOSS_DICE itself only
	--carries a single event_player (the primary Duel.TossDice caller) even
	--when both players roll in one call (count1/count2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.checkdice)
	c:RegisterEffect(e2)
	--If a die result is 1, that player chooses 1 effect (each player once per chain)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(0)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetTarget(s.dicetg)
	e3:SetOperation(s.diceop)
	c:RegisterEffect(e3)
end
--filter: card with a dice rolling effect
function s.thfilter(c)
	return c:IsEffectProperty(aux.EffectCategoryFilter(CATEGORY_DICE)) and c:IsAbleToHand()
end
--activation effect processing
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--detect which side(s) actually rolled a 1 this event, and re-raise a
--custom event with the correct event_player for each qualifying side
--(ep alone can't distinguish this: it's always the primary TossDice caller,
--even when count2 dice belong to the other player)
function s.hasone(dc,from,to)
	for i=from,to do
		if dc[i]==1 then return true end
	end
	return false
end
function s.checkdice(e,tp,eg,ep,ev,re,r,rp)
	local ct1=bit.band(ev,0xffff)
	local ct2=bit.rshift(ev,16)
	local dc={Duel.GetDiceResult()}
	local c=e:GetHandler()
	if s.hasone(dc,1,ct1) then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,re,r,rp,ep,0)
	end
	if ct2>0 and s.hasone(dc,ct1+1,ct1+ct2) then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,re,r,rp,1-ep,0)
	end
end
--filter: opponent's monster (destroy)
function s.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
--filter: opponent's monster (negate)
function s.disfilter(c)
	return aux.NegateMonsterFilter(c)
end
--filter: monster in GY (special summon)
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--filter: destroying this card leaves at least 1 negatable monster
function s.desleave(c,g)
	return g:IsExists(s.disfilter,1,c)
end
function s.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	--option 1: destroy up to 3 monsters on opponent's field
	local b1=Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil)
	--option 2: destroy 1 opponent's monster and negate 1 opponent's monster's effects (need 2+)
	local b2=Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,2,nil)
		and Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_MZONE,1,nil)
	--option 3: special summon 1 monster from your GY
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,3),1},
		{b2,aux.Stringid(id,4),2},
		{b3,aux.Stringid(id,5),3})
	--use chain info to avoid label conflict when both players activate via BOTH_SIDE
	Duel.SetTargetParam(op)
	if op==1 then
		e:SetCategory(CATEGORY_DESTROY)
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif op==2 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif op==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.diceop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if op==1 then
		--destroy up to 3 opponent's monsters
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,math.min(#g,3),nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	elseif op==2 then
		--destroy 1 and negate 1 (must leave a negatable monster if possible)
		local g1=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
		if #g1>0 then
			local dg1=g1:Filter(s.desleave,nil,g1)
			local sg
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			if #dg1>0 then
				sg=dg1:Select(tp,1,1,nil)
			else
				sg=g1:Select(tp,1,1,nil)
			end
			if Duel.Destroy(sg,REASON_EFFECT)>0 then
				local dg=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_MZONE,nil)
				if #dg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
					local tc=dg:Select(tp,1,1,nil):GetFirst()
					if tc:IsCanBeDisabledByEffect(e,true) then
						Duel.NegateRelatedChain(tc,RESET_TURN_SET)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetValue(RESET_TURN_SET)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e2)
					end
				end
			end
		end
	elseif op==3 then
		--special summon 1 monster from GY
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
