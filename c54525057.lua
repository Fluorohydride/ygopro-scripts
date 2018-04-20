--星辰のパラディオン
function c54525057.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,54525057)
	e1:SetCondition(c54525057.spcon)
	e1:SetValue(c54525057.spval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54525057,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,54525058)
	e2:SetCondition(c54525057.thcon)
	e2:SetTarget(c54525057.thtg)
	e2:SetOperation(c54525057.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c54525057.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c54525057.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c54525057.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c54525057.thfilter(c)
	return c:IsSetCard(0x116) and not c:IsCode(54525057) and c:IsAbleToHand()
end
function c54525057.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c54525057.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c54525057.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c54525057.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c54525057.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
