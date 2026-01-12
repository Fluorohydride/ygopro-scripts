--竜呼双搏
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--place
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_DESTROYED)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return (c:IsSetCard(0xf9) and c:IsType(TYPE_MONSTER)
		or c:IsSetCard(0xda,0xc7) and c:IsType(TYPE_PENDULUM)) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_GRAVE)
		and c:IsPreviousSetCard(0xf9) and c:IsSetCard(0xf9) and c:IsType(TYPE_MONSTER)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.tgfilter(c,e,tp)
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(tp) then
		if not c:IsAbleToChangeControler() then return false end
		r=LOCATION_REASON_CONTROL
	end
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,r)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp)
		and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_GRAVE)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=eg:Filter(s.cfilter,nil,tp):Filter(s.tgfilter,nil,e,tp)
	if chkc then return mg:IsContains(chkc) end
	if chk==0 then return mg:GetCount()>0 end
	local g=mg
	if mg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=mg:Select(tp,1,1,nil)
	end
	Duel.SetTargetCard(g)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsType(TYPE_MONSTER) and aux.NecroValleyFilter()(tc)
		and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
