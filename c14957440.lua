--落魂
function c14957440.initial_effect(c)
	c:EnableCounterPermit(0x59,LOCATION_MZONE)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c14957440.atklm)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--sp token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14957440,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,14957440)
	e2:SetCondition(c14957440.tkcon)
	e2:SetTarget(c14957440.tktg)
	e2:SetOperation(c14957440.tkop)
	c:RegisterEffect(e2)
end
function c14957440.atkfilter(c)
	return c:IsFacedown() or c:IsFaceup() and not c:IsType(TYPE_TUNER)
end
function c14957440.atklm(e)
	return Duel.IsExistingMatchingCard(c14957440.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c14957440.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c14957440.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14957440.cfilter,1,nil,1-tp)
end
function c14957440.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x59,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c14957440.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():AddCounter(0x59,1)~=0 and ft>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,14957441,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH) then
		Duel.BreakEffect()
		local ct=c:GetCounter(0x59)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if ct>ft then ct=ft end
		while ct>0 do
			local token=Duel.CreateToken(tp,14957441)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(c:GetCounter(0x59))
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK)
			e2:SetValue(c:GetCounter(0x59)*500)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_DEFENSE)
			e3:SetValue(c:GetCounter(0x59)*500)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e3)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			ct=ct-1
			if ct>0 and not Duel.SelectYesNo(tp,aux.Stringid(14957440,1)) then ct=0 end
		end
		Duel.SpecialSummonComplete()
	end
end
