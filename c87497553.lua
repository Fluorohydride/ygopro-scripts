--テスタメント・パラディオン
function c87497553.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,87497553+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c87497553.target)
	e1:SetOperation(c87497553.activate)
	c:RegisterEffect(e1)
end
function c87497553.battlecheck(tp)
	if not Duel.CheckEvent(EVENT_BATTLED) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	local res=a:IsType(TYPE_LINK) and a:IsSetCard(0x116)
		and d:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsPlayerCanDraw(tp,a:GetLink())
	return res,a
end
function c87497553.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetCurrentPhase()~=PHASE_DAMAGE
	local b2,a=c87497553.battlecheck(tp)
	if chk==0 then return b1 or b2 end
	if b1 then
		e:SetLabel(1)
		Duel.SelectOption(tp,aux.Stringid(87497553,0))
		e:SetCategory(0)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	else
		e:SetLabel(2)
		Duel.SelectOption(tp,aux.Stringid(87497553,1))
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
		e:SetLabelObject(a)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(a:GetLink())
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,a:GetLink())
	end
end
function c87497553.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c87497553.actop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		local a=e:GetLabelObject()
		if a:IsRelateToBattle() then
			Duel.Draw(p,a:GetLink(),REASON_EFFECT)
		end
	end
end
function c87497553.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x116) and ep==tp then
		Duel.SetChainLimit(c87497553.chainlm)
	end
end
function c87497553.chainlm(e,rp,tp)
	return tp==rp
end
