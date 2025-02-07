--捕食植物モーレイ・ネペンテス
function c22011689.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c22011689.atkval)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22011689,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c22011689.eqcon)
	e2:SetTarget(c22011689.eqtg)
	e2:SetOperation(c22011689.eqop)
	c:RegisterEffect(e2)
	--destroy + lp gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22011689,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c22011689.target)
	e3:SetOperation(c22011689.operation)
	c:RegisterEffect(e3)
end
function c22011689.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1041)*200
end
function c22011689.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsType(TYPE_MONSTER)
		and (bc:IsLocation(LOCATION_GRAVE) or bc:IsFaceup() and bc:IsLocation(LOCATION_EXTRA+LOCATION_REMOVED))
end
function c22011689.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,bc,1,0,0)
end
function c22011689.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c22011689.eqlimit)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(22011689,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c22011689.eqlimit(e,c)
	return e:GetOwner()==c
end
function c22011689.desfilter(c,ec)
	return c:GetFlagEffect(22011689)~=0 and c:GetEquipTarget()==ec and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function c22011689.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c22011689.desfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c22011689.desfilter,tp,LOCATION_SZONE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22011689.desfilter,tp,LOCATION_SZONE,0,1,1,nil,c)
	local atk=g:GetFirst():GetTextAttack()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if atk>0 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
	end
end
function c22011689.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local atk=tc:GetTextAttack()
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
