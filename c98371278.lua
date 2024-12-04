--DMZドラゴン
function c98371278.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98371278,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c98371278.eqtg)
	e1:SetOperation(c98371278.eqop)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98371278,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c98371278.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98371278.atktg)
	e2:SetOperation(c98371278.atkop)
	c:RegisterEffect(e2)
end
function c98371278.eqfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(4)
end
function c98371278.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c98371278.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c98371278.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c98371278.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c98371278.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98371278.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g:GetFirst(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g:GetFirst(),1,0,0)
end
function c98371278.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	local tc2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	if tc1 and tc2 and tc1:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc1) then
		if not Duel.Equip(tp,tc1,tc2) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c98371278.eqlimit)
		e1:SetLabelObject(tc2)
		tc1:RegisterEffect(e1)
		--atkup
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e2)
	end
end
function c98371278.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c98371278.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:GetEquipCount()>0 and at:IsChainAttackable()
end
function c98371278.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetAttacker():GetEquipGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c98371278.atkop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local g=at:GetEquipGroup()
	if at:IsControler(tp) and Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.ChainAttack()
	end
end
