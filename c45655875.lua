--魔鍵召獣－アンシャラボラス
---@param c Card
function c45655875.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x165),c45655875.ffilter,true)
	--fusion success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45655875,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,45655875)
	e1:SetCondition(c45655875.thcon)
	e1:SetTarget(c45655875.thtg)
	e1:SetOperation(c45655875.thop)
	c:RegisterEffect(e1)
	--Position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45655875,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c45655875.sptg)
	e2:SetOperation(c45655875.spop)
	c:RegisterEffect(e2)
	--Battle remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c45655875.ffilter(c)
	return c:IsFusionType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN)
end
function c45655875.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c45655875.thfilter(c)
	return c:IsCode(99426088) and c:IsAbleToHand()
end
function c45655875.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45655875.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c45655875.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45655875.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c45655875.gfilter(c,att)
	return c:IsAttribute(att) and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x165))
end
function c45655875.filter(c,tp)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
		and Duel.IsExistingMatchingCard(c45655875.gfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetAttribute())
end
function c45655875.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c45655875.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c45655875.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	local g=Duel.SelectTarget(tp,c45655875.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c45655875.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsPosition(POS_FACEUP_ATTACK) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
