--エターナル・サイバー
function c32768230.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,32768230)
	e1:SetTarget(c32768230.target)
	e1:SetOperation(c32768230.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,32768231)
	e2:SetTarget(c32768230.reptg)
	e2:SetValue(c32768230.repval)
	e2:SetOperation(c32768230.repop)
	c:RegisterEffect(e2)
end
function c32768230.spfilter(c,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsSetCard(0x93) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_FUSION)
		and (c:IsAbleToExtra() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)))
end
function c32768230.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c32768230.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c32768230.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c32768230.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function c32768230.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,true,false)
			and (not tc:IsAbleToExtra() or Duel.SelectOption(tp,aux.Stringid(32768230,0),1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function c32768230.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x93) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_FUSION)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c32768230.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c32768230.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c32768230.repval(e,c)
	return c32768230.repfilter(c,e:GetHandlerPlayer())
end
function c32768230.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
