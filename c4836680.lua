--EMオッドアイズ・プリースト
---@param c Card
function c4836680.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,4836680)
	e1:SetTarget(c4836680.thtg)
	e1:SetOperation(c4836680.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,4836681)
	e2:SetCondition(c4836680.spcon)
	e2:SetCost(c4836680.spcost)
	e2:SetTarget(c4836680.sptg)
	e2:SetOperation(c4836680.spop)
	c:RegisterEffect(e2)
	--to extra or grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,4836681)
	e3:SetCondition(c4836680.tgcon)
	e3:SetTarget(c4836680.tgtg)
	e3:SetOperation(c4836680.tgop)
	c:RegisterEffect(e3)
end
function c4836680.thfilter(c)
	return c:IsSetCard(0x9f,0x99) and c:IsAbleToHand()
end
function c4836680.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4836680.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4836680.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c4836680.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c4836680.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c4836680.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) and e:GetHandler():IsAttackPos()
end
function c4836680.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c4836680.spfilter(c,e,tp)
	return c:IsSetCard(0x9f,0x99) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4836680.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4836680.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c4836680.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4836680.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4836680.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c4836680.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) and e:GetHandler():IsDefensePos()
end
function c4836680.tgfilter(c)
	return c:IsSetCard(0x9f,0x99) and c:IsType(TYPE_PENDULUM)
		and (c:IsAbleToExtra() or c:IsAbleToGrave())
end
function c4836680.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4836680.tgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c4836680.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c4836680.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToGrave() and (not tc:IsAbleToExtra() or Duel.SelectOption(tp,aux.Stringid(4836680,0),1191)==1) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
	end
end
