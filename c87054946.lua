--焔凰神－ネフティス
function c87054946.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c87054946.lcheck)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c87054946.regcon)
	e1:SetOperation(c87054946.regop)
	c:RegisterEffect(e1)
	--cannot select battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c87054946.atcon)
	e2:SetValue(c87054946.atlimit)
	c:RegisterEffect(e2)
end
function c87054946.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function c87054946.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c87054946.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_RITUAL)
	if ct>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(87054946,0))
	end
	if ct>=2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(1200)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetValue(1)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(87054946,1))
	end
	if ct==3 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetRange(LOCATION_MZONE)
		e4:SetValue(1200)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e5:SetRange(LOCATION_MZONE)
		e5:SetValue(1)
		c:RegisterEffect(e5)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(87054946,2))
	end
end
function c87054946.atcon(e)
	return e:GetHandler():GetSequence()>4
end
function c87054946.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x11f) and c:GetSequence()<5
end
