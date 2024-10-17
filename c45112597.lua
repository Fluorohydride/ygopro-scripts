--世海龍ジーランティス
---@param c Card
function c45112597.initial_effect(c)
	c:SetUniqueOnField(1,0,45112597)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1)
	c:EnableReviveLimit()
	--remove & special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45112597,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,45112597)
	e1:SetTarget(c45112597.rmtg)
	e1:SetOperation(c45112597.rmop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45112597,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,45112598)
	e2:SetCondition(c45112597.descon)
	e2:SetTarget(c45112597.destg)
	e2:SetOperation(c45112597.desop)
	c:RegisterEffect(e2)
end
function c45112597.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function c45112597.spfilter(c,e,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE,c:GetControler())
end
function c45112597.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.AdjustAll()
		local og=Duel.GetOperatedGroup():Filter(c45112597.spfilter,nil,e,tp)
		if #og<=0 then return end
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		if ft1<=0 and ft2<=0 then return end
		local spg=Group.CreateGroup()
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if ft1>0 and ft2>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				spg=og:Select(tp,1,1,nil)
			else
				local p
				if ft1>0 and ft2<=0 then
					p=tp
				end
				if ft1<=0 and ft2>0 then
					p=1-tp
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				spg=og:FilterSelect(tp,Card.IsControler,1,1,nil,p)
			end
		else
			local p=tp
			for i=1,2 do
				local sg=og:Filter(Card.IsControler,nil,p)
				local ft=Duel.GetLocationCount(p,LOCATION_MZONE,tp)
				if #sg>ft then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					sg=sg:Select(tp,ft,ft,nil)
				end
				spg:Merge(sg)
				p=1-tp
			end
		end
		if #spg>0 then
			Duel.BreakEffect()
			local tc=spg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tc:GetControler(),false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
				tc=spg:GetNext()
			end
			Duel.SpecialSummonComplete()
			local cg=spg:Filter(Card.IsFacedown,nil)
			if #cg>0 then
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c45112597.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c45112597.filter(c)
	return c:GetMutualLinkedGroupCount()>0
end
function c45112597.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45112597.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c45112597.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c45112597.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
