--フォーチュンレディ・パスティー
function c57869175.initial_effect(c)
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c57869175.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--level up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(57869175,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c57869175.lvcon)
	e3:SetOperation(c57869175.lvop)
	c:RegisterEffect(e3)
	--remove,lvup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(57869175,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,57869175)
	e4:SetTarget(c57869175.rmtg)
	e4:SetOperation(c57869175.rmop)
	c:RegisterEffect(e4)
end
function c57869175.value(e,c)
	return c:GetLevel()*200
end
function c57869175.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c57869175.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsLevelAbove(12) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c57869175.tgfilter(c,tp)
	return c:IsSetCard(0x31) and c:IsLevelAbove(1) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c57869175.rmfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,c)
end
function c57869175.rmfilter(c)
	return (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c57869175.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c57869175.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c57869175.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c57869175.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
end
function c57869175.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ec=nil
	if tc:IsRelateToEffect(e) then
		ec=tc
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c57869175.rmfilter),tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,99,ec,tp)
	if rg:GetCount()>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local lv=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if lv>0 and tc:IsRelateToEffect(e) then
			local op=0
			if tc:IsLevelBelow(lv) then op=Duel.SelectOption(tp,aux.Stringid(57869175,2))
			else op=Duel.SelectOption(tp,aux.Stringid(57869175,2),aux.Stringid(57869175,3)) end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			if op==0 then
				e1:SetValue(lv)
			else
				e1:SetValue(-lv)
			end
			tc:RegisterEffect(e1)
		end
	end
end
