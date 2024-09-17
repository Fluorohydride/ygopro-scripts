--連慄砲固定式
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.rcheck(g,ct)
	return g:GetSum(s.lv_or_rk)==ct and g:FilterCount(Card.IsType,nil,TYPE_XYZ)==2 and g:IsExists(s.xyzfilter,1,nil,g)
end
function s.xyzfilter(c,g)
	return g:IsExists(Card.IsRank,1,c,c:GetRank())
end
function s.lv_or_rk(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_FUSION+TYPE_XYZ):Filter(Card.IsAbleToRemove,nil,POS_FACEUP)
	if chk==0 then return g and g:CheckSubGroup(s.rcheck,3,3,ct) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_EXTRA)
end
function s.lrfilter(c,tp)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsType,Card.IsFaceupEx),tp,LOCATION_REMOVED,0,nil,TYPE_FUSION+TYPE_XYZ):Filter(Card.IsAbleToExtra,nil)
	local lr=0
	if c:IsType(TYPE_XYZ) then lr=c:GetRank() else lr=c:GetLevel() end
	return c:IsFaceup() and g:CheckSubGroup(s.lrcheck,2,2,lr)
end
function s.lrcheck(g,ct)
	return g:GetSum(s.lv_or_rk)==ct and g:FilterCount(Card.IsType,nil,TYPE_XYZ)==g:FilterCount(Card.IsType,nil,TYPE_FUSION)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_FUSION+TYPE_XYZ):Filter(Card.IsAbleToRemove,nil,POS_FACEUP)
	if not g:CheckSubGroup(s.rcheck,3,3,ct) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,s.rcheck,false,3,3,ct)
	if not sg or not Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==3 then return false end
	if Duel.IsExistingMatchingCard(s.lrfilter,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,s.lrfilter,tp,0,LOCATION_MZONE,1,1,nil,tp):GetFirst()
		local tg=Duel.GetMatchingGroup(aux.AND(Card.IsType,Card.IsFaceupEx),tp,LOCATION_REMOVED,0,nil,TYPE_FUSION+TYPE_XYZ):Filter(Card.IsAbleToExtra,nil)
		local lr=0
		if tc:IsType(TYPE_XYZ) then lr=tc:GetRank() else lr=tc:GetLevel() end
		local rg=tg:SelectSubGroup(tp,s.lrcheck,false,2,2,lr)
		if rg then
			Duel.ConfirmCards(1-tp,rg)
			if Duel.SendtoDeck(rg,nil,1,REASON_EFFECT)==2 then
				Duel.BreakEffect()
				local qg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,POS_FACEUP)
				Duel.Remove(qg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
