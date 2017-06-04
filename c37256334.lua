--EMカード・ガードナー
function c37256334.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--defup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37256334,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c37256334.deftg)
	e1:SetOperation(c37256334.defop)
	c:RegisterEffect(e1)
	--defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c37256334.defval)
	c:RegisterEffect(e2)
end
function c37256334.deffilter1(c,def)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:GetDefense()~=def
end
function c37256334.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_DEFENSE)
	local def=g:GetSum(Card.GetBaseDefense)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c37256334.deffilter1(chkc,def) end
	if chk==0 then return Duel.IsExistingTarget(c37256334.deffilter1,tp,LOCATION_MZONE,0,1,nil,def) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c37256334.deffilter1,tp,LOCATION_MZONE,0,1,1,nil,def)
end
function c37256334.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_DEFENSE)
		local def=g:GetSum(Card.GetBaseDefense)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(def)
		tc:RegisterEffect(e1)
	end
end
function c37256334.deffilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x9f)
end
function c37256334.defval(e,c)
	local g=Duel.GetMatchingGroup(c37256334.deffilter2,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetBaseDefense)
end
