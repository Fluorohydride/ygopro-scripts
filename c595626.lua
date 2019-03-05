--アンクリボー
function c595626.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(595626,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,595626)
	e1:SetCondition(c595626.spcon)
	e1:SetCost(c595626.spcost)
	e1:SetTarget(c595626.sptg)
	e1:SetOperation(c595626.spop)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(595626,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,595627)
	e2:SetCondition(c595626.thcon)
	e2:SetTarget(c595626.thtg)
	e2:SetOperation(c595626.thop)
	c:RegisterEffect(e2)
end
function c595626.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c595626.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c595626.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c595626.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c595626.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c595626.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c595626.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c595626.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(595626,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c595626.tgcon)
		e1:SetOperation(c595626.tgop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c595626.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(595626)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c595626.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
function c595626.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c595626.thfilter(c)
	return c:IsCode(83764718) and c:IsAbleToHand()
end
function c595626.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c595626.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c595626.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetOperation(c595626.thop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c595626.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c595626.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
