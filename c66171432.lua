--超こいこい
function c66171432.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66171432,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66171432+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c66171432.target)
	e1:SetOperation(c66171432.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66171432,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c66171432.spcost)
	e2:SetTarget(c66171432.sptg)
	e2:SetOperation(c66171432.spop)
	c:RegisterEffect(e2)
end
function c66171432.filter(c,e,tp)
	return c:IsSetCard(0xe6) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c66171432.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanRemove(tp)
		and Duel.IsPlayerCanSpecialSummon(tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsPlayerAffectedByEffect(tp,63060238)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c66171432.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanRemove(tp) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local sg=g:Filter(c66171432.filter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if sg:GetCount()>0 and ft>0 then
			if sg:GetCount()>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,ft,ft,nil)
			end
			g:Sub(sg)
			local tc=sg:GetFirst()
			while tc do
				if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
					if tc:GetLevel()>0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CHANGE_LEVEL)
						e1:SetValue(2)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
					end
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_EFFECT)
					e3:SetValue(RESET_TURN_SET)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
				tc=sg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if ct>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-ct*1000)
		end
	end
end
function c66171432.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.CheckReleaseGroup(tp,nil,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c66171432.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c66171432.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c66171432.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66171432.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
