--パワー・ツール・ブレイバー・ドラゴン
---@param c Card
function c63265554.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63265554,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,63265554)
	e1:SetTarget(c63265554.eqtg)
	e1:SetOperation(c63265554.eqop)
	c:RegisterEffect(e1)
	--pos or neg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63265554,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,63265555)
	e2:SetCondition(c63265554.pncon)
	e2:SetCost(c63265554.pncost)
	e2:SetTarget(c63265554.pntg)
	e2:SetOperation(c63265554.pnop)
	c:RegisterEffect(e2)
end
function c63265554.eqfilter(c,ec,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function c63265554.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c63265554.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c63265554.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	if ft<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c63265554.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,3))
	if not sg then return end
	local tc=sg:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=sg:GetNext()
	end
	Duel.EquipComplete()
end
function c63265554.pncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c63265554.cfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function c63265554.pncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetEquipGroup()
	if chk==0 then return cg:IsExists(c63265554.cfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=cg:FilterSelect(tp,c63265554.cfilter,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c63265554.pnfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c63265554.pntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c63265554.pnfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c63265554.pnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c63265554.pnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c63265554.pnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local b1=tc:IsCanChangePosition()
	local b2=aux.NegateMonsterFilter(tc)
	local op=-1
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(63265554,2),aux.Stringid(63265554,3))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	end
	if op==0 then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	elseif op==1 then
		if tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
		end
	end
end
