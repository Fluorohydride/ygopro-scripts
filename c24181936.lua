--闇味鍋パーティー
function c24181936.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attack select
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24181936,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,24181936)
	e2:SetCondition(c24181936.atkcon1)
	e2:SetTarget(c24181936.atktg1)
	e2:SetOperation(c24181936.atkop1)
	c:RegisterEffect(e2)
end
function c24181936.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c24181936.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c24181936.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(24181936)==0 then
			tc:RegisterFlagEffect(24181936,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCondition(c24181936.effcon)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetCondition(c24181936.atkcon2)
			e2:SetTarget(c24181936.atktg)
			e2:SetValue(c24181936.atkval)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c24181936.effcon(e)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(24181936)~=0 and Duel.GetAttacker()==tc
end
function c24181936.atkcon2(e)
	local tc=e:GetLabelObject()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and tc:GetFlagEffect(24181936)~=0 and Duel.GetAttacker()==tc and Duel.GetAttackTarget()~=nil
end
function c24181936.atktg(e,c)
	return c==Duel.GetAttacker()
end
function c24181936.atkval(e,c)
	return c:GetBaseAttack()
end
