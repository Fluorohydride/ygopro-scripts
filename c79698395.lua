--Realm of Danger!
function c79698395.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c79698395.target)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--eff gain/direct attack/cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79698395,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79698395.efftg)
	e3:SetOperation(c79698395.effop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTarget(c79698395.tgtg)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	c:RegisterEffect(e5)
end
function c79698395.target(e,c)
	return c:IsSetCard(0x11e) and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c79698395.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x11e)
end
function c79698395.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c79698395.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79698395.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c79698395.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c79698395.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c79698395.tgtg(e,c)
	return e:GetHandler():IsHasCardTarget(c)
end
