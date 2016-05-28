--次元融合
function c23557835.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c23557835.cost)
	e1:SetTarget(c23557835.tg)
	e1:SetOperation(c23557835.op)
	c:RegisterEffect(e1)
end
function c23557835.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23557835.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c23557835.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c23557835.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) or
		(Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c23557835.filter,tp,0,LOCATION_REMOVED,1,nil,e,1-tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,2,LOCATION_REMOVED)
end
function c23557835.op(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c23557835.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c23557835.filter,tp,0,LOCATION_REMOVED,nil,e,1-tp)
	if ft1<=0 or g1:GetCount()==0 or (ft1>1 and g1:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if ft2<=0 or g2:GetCount()==0 or (ft2>1 and g2:GetCount()>1 and Duel.IsPlayerAffectedByEffect(1-tp,59822133)) then return end
	if ft1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=g1:Select(tp,ft1,ft1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc=g:GetNext()
				count=count+1
			end
		end
	end
	if ft2>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=g2:Select(1-tp,ft2,ft2,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
				tc=g:GetNext()
				count=count+1
			end
		end
	end
	if count>0 then Duel.SpecialSummonComplete() end
end
