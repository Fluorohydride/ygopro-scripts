--渇きの風
function c28265983.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--activate(destroy)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28265983,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RECOVER)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,28265983)
	e1:SetCondition(c28265983.descon1)
	e1:SetTarget(c28265983.destg1)
	e1:SetOperation(c28265983.desop1)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28265983,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,28265984)
	e3:SetCondition(c28265983.descon2)
	e3:SetCost(c28265983.descost2)
	e3:SetTarget(c28265983.destg2)
	e3:SetOperation(c28265983.desop2)
	c:RegisterEffect(e3)
end
function c28265983.descon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c28265983.desfilter1(c)
	return c:IsFaceup()
end
function c28265983.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c28265983.desfilter1(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c28265983.desfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c28265983.desop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c28265983.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc9)
end
function c28265983.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28265983.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLP(tp)-Duel.GetLP(1-tp)>=3000
end
function c28265983.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)-Duel.GetLP(1-tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp) end
	Duel.PayLPCost(tp,lp)
	e:SetLabel(lp)
end
function c28265983.desfilter2(c,num)
	return c:IsFaceup() and c:IsAttackBelow(num)
end
function c28265983.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)-Duel.GetLP(1-tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c28265983.desfilter2,tp,0,LOCATION_MZONE,1,nil,lp) end
	local g=Duel.GetMatchingGroup(c28265983.desfilter2,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28265983.gselect(g,num)
	return g:GetSum(Card.GetAttack)<=num
end
function c28265983.desop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local num=e:GetLabel()
	local g=Duel.GetMatchingGroup(c28265983.desfilter2,tp,0,LOCATION_MZONE,nil,num)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:SelectSubGroup(tp,c28265983.gselect,false,1,#g,num)
	Duel.Destroy(dg,REASON_EFFECT)
end
