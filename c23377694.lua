--EMオオヤヤドカリ
function c23377694.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c23377694.atktg)
	e1:SetOperation(c23377694.atkop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c23377694.spcon)
	e2:SetTarget(c23377694.sptg)
	e2:SetOperation(c23377694.spop)
	c:RegisterEffect(e2)
end
function c23377694.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c23377694.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c23377694.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23377694.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c23377694.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c23377694.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x9f)
end
function c23377694.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(c23377694.filter2,tp,LOCATION_MZONE,0,nil)
	if ct>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c23377694.cfilter(c,tp)
	return c:IsSetCard(0x9f) and c:GetPreviousControler()==tp
end
function c23377694.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23377694.cfilter,1,nil,tp)
end
function c23377694.spfilter(c,e,tp)
	return (c:IsSetCard(0x9f) or c:IsSetCard(0x99)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23377694.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c23377694.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c23377694.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c23377694.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c23377694.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
