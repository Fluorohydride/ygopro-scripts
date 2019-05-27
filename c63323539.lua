--トロイボム
function c63323539.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CONTROL_CHANGED)
	e1:SetTarget(c63323539.target)
	e1:SetOperation(c63323539.operation)
	c:RegisterEffect(e1)
end
function c63323539.filter(c,e,tp)
	return c:IsControler(1-tp) and c:IsCanBeEffectTarget(e)
end
function c63323539.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c63323539.filter(chkc,e,tp) end
	if chk==0 then return r==REASON_EFFECT and rp==1-tp
		and eg:IsExists(c63323539.tgfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=eg:FilterSelect(tp,c63323539.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack())
end
function c63323539.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local atk=tc:GetAttack()
	if atk<0 or tc:IsFacedown() then atk=0 end
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
