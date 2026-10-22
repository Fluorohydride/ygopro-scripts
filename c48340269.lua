--Angelechy Verdict
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.tefilter(c)
	return c:IsSetCard(0x1e2) and c:IsCardType(TYPE_MONSTER) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(s.tefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local sg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return ct>0 and ct<5 and sg:GetCount()>0
		or ct>4 and g:GetCount()>0 end
	if ct<5 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.tefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 and ct<5 then
		local sg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			local sc=tg:GetFirst()
			if not sc:IsCanBeDisabledByEffect(e) then return end
			Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			sc:RegisterEffect(e3)
			if sc:IsType(TYPE_TRAPMONSTER) then
				local e4=e2:Clone()
				e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				sc:RegisterEffect(e4)
			end
		end
	elseif ct>4 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function s.tgfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1e2) and c:IsAbleToGrave()
end
function s.setfilter(c,tp)
	return c:IsSetCard(0x1e2) and not c:IsForbidden()
		and not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_SZONE,0,1,nil,c:GetCode())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local gg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if gg:GetCount()==0 then return end
	if gg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) then
		Duel.HintSelection(gg)
	end
	if Duel.SendtoGrave(gg,REASON_EFFECT)~=0 and gg:GetFirst():IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local pg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if pg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
end
