--海神の依代
function c57511992.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--choose effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57511992,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,57511992)
	e1:SetTarget(c57511992.target)
	e1:SetOperation(c57511992.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,57511993)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c57511992.thtg)
	e2:SetOperation(c57511992.thop)
	c:RegisterEffect(e2)
end
function c57511992.tgfilter(c,e,tp,ec,spchk)
	return c:IsAttribute(ATTRIBUTE_WATER)
		and (c:IsLevelAbove(1) and ec:IsLevelAbove(1) and (not c:IsLevel(ec:GetLevel()) or not c:IsCode(ec:GetCode()))
			or spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
end
function c57511992.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local spchk=Duel.IsEnvironment(22702055) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c57511992.tgfilter(chkc,e,tp,c,spchk) end
	if chk==0 then return Duel.IsExistingTarget(c57511992.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,spchk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c57511992.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c,spchk)
end
function c57511992.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b1=tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() and c:IsLevelAbove(1)
		and tc:IsLevelAbove(1) and (not c:IsLevel(tc:GetLevel()) or not c:IsCode(tc:GetCode()))
	local b2=tc:IsRelateToEffect(e) and Duel.IsEnvironment(22702055) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and aux.NecroValleyFilter()(tc) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	if b1 or b2 then
		local s
		if b1 and b2 then
			s=Duel.SelectOption(tp,aux.Stringid(57511992,1),aux.Stringid(57511992,2))
		elseif b1 then
			s=Duel.SelectOption(tp,aux.Stringid(57511992,1))
		else
			s=Duel.SelectOption(tp,aux.Stringid(57511992,2))+1
		end
		if s==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(tc:GetCode())
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(tc:GetLevel())
			c:RegisterEffect(e2)
		end
		if s==1 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c57511992.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c57511992.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c57511992.thfilter(c)
	return c:IsCode(22702055) and c:IsAbleToHand()
end
function c57511992.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c57511992.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c57511992.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c57511992.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c57511992.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
