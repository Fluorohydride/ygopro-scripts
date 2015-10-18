--Magic Sea Castle Aigaion
function c10678778.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10678778,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10678778)
	e1:SetOperation(c10678778.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10678778,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,106787782)
	e2:SetTarget(c10678778.target)
	e2:SetOperation(c10678778.activate)
	c:RegisterEffect(e2)
end
function c10678778.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
	if g:GetCount()==0 then return end
	local tc=g:RandomSelect(tp,1):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local atk=tc:GetAttack()
	if atk<0 then atk=0 end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end

function c10678778.filter(c)
	local ctype=c:GetType()
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO)) and c:IsAbleToHand()
	 and Duel.IsExistingTarget(c10678778.filter2,tp,0,LOCATION_MZONE,1,nil,ctype)
end
function c10678778.filter2(c,ctype)
	return c:GetType()==ctype
end
function c10678778.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c10678778.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10678778.filter,tp,0,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10678778.filter,tp,0,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10678778.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		local g=Duel.SelectMatchingCard(tp,c10678778.filter2,tp,0,LOCATION_MZONE,1,1,nil,tc:GetType())
		local tc2=g:GetFirst()
		Duel.Destroy(tc2,REASON_EFFECT)
	end
end
