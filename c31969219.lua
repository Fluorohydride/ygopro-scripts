--影の災い
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY|CATEGORY_REMOVE|CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.rmfdfilter(c,code,tp)
	return c:IsCode(code) and c:IsFaceupEx() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.rmfilter(c,tp)
	if not c:IsFaceup() then return false end
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_GRAVE,nil,c:GetCode())
	local ct=g:GetCount()
	if ct==0 then return false end
	if ct==1 then return true end
	if ct==2 then return c:IsAbleToRemove() end
	if ct>2 then return Duel.IsExistingMatchingCard(s.rmfdfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,c:GetCode(),tp) end
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and s.rmfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectTarget(tp,s.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	local sc=sg:GetFirst()
	if sc then
		local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,0,LOCATION_GRAVE,nil,sc:GetCode())
		if ct==1 then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
		elseif ct==2 then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
		elseif ct>2 then
			local rg=Duel.GetMatchingGroup(s.rmfdfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,sc:GetCode(),tp)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
		end
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,0,LOCATION_GRAVE,nil,tc:GetCode())
		if ct==1 then
			Duel.Destroy(tc,REASON_EFFECT)
		elseif ct==2 then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		elseif ct>2 then
			local rg=Duel.GetMatchingGroup(s.rmfdfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tc:GetCode(),tp)
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
