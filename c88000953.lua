--ラスタライガー
function c88000953.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN)),2)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88000953,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,88000953)
	e1:SetTarget(c88000953.atktg)
	e1:SetOperation(c88000953.atkop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88000953,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88000954)
	e2:SetCost(c88000953.descost)
	e2:SetTarget(c88000953.destg)
	e2:SetOperation(c88000953.desop)
	c:RegisterEffect(e2)
end
function c88000953.atkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsAttackAbove(1)
end
function c88000953.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c88000953.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88000953.atkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c88000953.atkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
end
function c88000953.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c88000953.costfilter(c,tp,g)
	return g:IsContains(c)
		and Duel.IsExistingMatchingCard(c88000953.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,Group.FromCards(c))
end
function c88000953.desfilter(c,g)
	local ec=c:GetEquipTarget()
	return not ec or not g:IsContains(ec)
end
function c88000953.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c88000953.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g:GetCount(),g,g)
		and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function c88000953.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c88000953.costfilter,1,nil,tp,lg) end
	local rg=Duel.GetReleaseGroup(tp):Filter(c88000953.costfilter,nil,tp,lg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c88000953.fselect,false,1,rg:GetCount(),tp)
	local ct=Duel.Release(sg,REASON_COST)
	e:SetLabel(ct)
end
function c88000953.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c88000953.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g:GetCount()>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,ct,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
