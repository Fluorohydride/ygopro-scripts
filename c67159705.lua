--アーマード・サイバーン
---@param c Card
function c67159705.initial_effect(c)
	aux.EnableUnionAttribute(c,c67159705.filter)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67159705,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c67159705.destg)
	e5:SetOperation(c67159705.desop)
	c:RegisterEffect(e5)
end
function c67159705.filter(c)
	return c:IsCode(70095154) or c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,70095154)
end
function c67159705.desfilter(c)
	return c:IsFaceup()
end
function c67159705.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c67159705.desfilter(chkc) end
	if chk==0 then return e:GetHandler():GetEquipTarget() and e:GetHandler():GetEquipTarget():GetAttack()>=1000
		and Duel.IsExistingTarget(c67159705.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c67159705.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67159705.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	if ec:GetAttack()<1000 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	ec:RegisterEffect(e1)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not ec:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
