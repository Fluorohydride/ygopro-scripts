--ストーム・サモナー
function c15935204.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(c15935204.reptg)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15935204,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c15935204.dmcon)
	e2:SetTarget(c15935204.dmtg)
	e2:SetOperation(c15935204.dmop)
	c:RegisterEffect(e2)
end
function c15935204.repfilter(c,e,tp)
	return c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsType(TYPE_TOKEN)
		and c:IsControler(1-tp) and c:IsReason(REASON_BATTLE) and c:GetReasonCard():IsRace(RACE_PSYCHO) and c:GetReasonCard()~=e:GetHandler()
		and c:GetLeaveFieldDest()==0 and c:GetDestination()~=LOCATION_DECK
end
function c15935204.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return r&REASON_BATTLE~=0 and eg:IsExists(c15935204.repfilter,1,nil,e,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(15935204,1)) then
		local tc=eg:Filter(c15935204.repfilter,nil,e,tp):GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetCondition(c15935204.recon)
		e1:SetValue(LOCATION_DECK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		return true
	else return false end
end
function c15935204.recon(e)
	local c=e:GetHandler()
	return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE)
end
function c15935204.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_BATTLE)
end
function c15935204.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetTargetPlayer(c:GetPreviousControler())
	Duel.SetTargetParam(c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,c:GetPreviousControler(),c:GetAttack())
end
function c15935204.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
