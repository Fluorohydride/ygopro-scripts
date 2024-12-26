--肆世壊の双牙
---@param c Card
function c95245571.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95245571,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95245571+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c95245571.cost)
	e1:SetTarget(c95245571.target)
	e1:SetOperation(c95245571.activate)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95245571,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE)
	e2:SetCondition(c95245571.cacon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c95245571.catg)
	e2:SetOperation(c95245571.caop)
	c:RegisterEffect(e2)
end
function c95245571.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c95245571.actfilter(c)
	return c:IsCode(56099748) and c:IsFaceup()
end
function c95245571.desfilter(c,check)
	return check or c:IsAbleToRemove()
end
function c95245571.descfilter(c,tc,ec,check)
	return c95245571.desfilter(c,check) and c:GetEquipTarget()~=tc and c~=ec
end
function c95245571.costfilter(c,ec,tp,check)
	if not c:IsSetCard(0x17a) then return false end
	return Duel.IsExistingTarget(c95245571.descfilter,tp,0,LOCATION_ONFIELD,2,c,c,ec,check)
end
function c95245571.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local check=not Duel.IsExistingMatchingCard(c95245571.actfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chkc then return chkc:IsOnField() and chkc~=c and c95245571.desfilter(chkc,check) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c95245571.costfilter,1,c,c,tp,check)
		else
			return Duel.IsExistingTarget(c95245571.desfilter,tp,0,LOCATION_ONFIELD,2,c,check)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c95245571.costfilter,1,1,c,c,tp,check)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c95245571.desfilter,tp,0,LOCATION_ONFIELD,2,2,c,check)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c95245571.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsExistingMatchingCard(c95245571.actfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
	else
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c95245571.cacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsLinkAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,3)
end
function c95245571.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,95245571)==0 end
end
function c95245571.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c95245571.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,95245571,RESET_PHASE+PHASE_END,0,1)
end
function c95245571.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_MZONE)
end
