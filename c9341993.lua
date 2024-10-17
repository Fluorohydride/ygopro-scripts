--魔救の救砕
---@param c Card
function c9341993.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9341993.cost)
	e1:SetTarget(c9341993.target)
	e1:SetOperation(c9341993.activate)
	c:RegisterEffect(e1)
end
function c9341993.costfilter(c,tp)
	return c:IsSetCard(0x140) and (c:IsControler(tp) or c:IsFaceup())
end
function c9341993.fselect(g,tp,exc)
	local dg=g:Clone()
	if exc then dg:AddCard(exc) end
	if Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g:GetCount()+1,dg) then
		Duel.SetSelectedCard(g)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c9341993.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	local g=Duel.GetReleaseGroup(tp):Filter(c9341993.costfilter,nil,tp)
	if chk==0 then return g:CheckSubGroup(c9341993.fselect,1,g:GetCount(),tp,exc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c9341993.fselect,false,1,g:GetCount(),tp,exc)
	aux.UseExtraReleaseCount(rg,tp)
	e:SetLabel(100,Duel.Release(rg,REASON_COST))
end
function c9341993.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	local check,ct=e:GetLabel()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc) end
	if check~=100 then ct=0 end
	e:SetLabel(0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct+1,ct+1,exc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9341993.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
