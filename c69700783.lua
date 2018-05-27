--ヴァンパイア・デザイア
function c69700783.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,69700783+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c69700783.target)
	e1:SetOperation(c69700783.activate)
	c:RegisterEffect(e1)
end
function c69700783.tgfilter1(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c69700783.tgfilter2,tp,LOCATION_DECK,0,1,nil,lv)
end
function c69700783.tgfilter2(c,lv)
	return c:IsSetCard(0x8e) and c:IsLevelAbove(0) and not c:IsLevel(lv) and c:IsAbleToGrave()
end
function c69700783.spfilter1(c,tp)
	return c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
end
function c69700783.spfilter2(c,e,tp)
	return c:IsSetCard(0x8e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c69700783.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c69700783.tgfilter1(chkc,tp)
		else
			return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c69700783.spfilter2(chkc,e,tp)
		end
	end
	local b1=Duel.IsExistingTarget(c69700783.tgfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c69700783.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingTarget(c69700783.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(69700783,0),aux.Stringid(69700783,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(69700783,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(69700783,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c69700783.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c69700783.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c69700783.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c69700783.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
			and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local lv=g:GetFirst():GetLevel()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	else
		local tc=Duel.GetFirstTarget()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c69700783.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
		if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 and tg:GetFirst():IsLocation(LOCATION_GRAVE)
			and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
