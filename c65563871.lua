--聖蔓の癒し手
function c65563871.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c65563871.mfilter,1,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65563871,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65563871.descon)
	e1:SetTarget(c65563871.destg)
	e1:SetOperation(c65563871.desop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65563871,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c65563871.rectg)
	e2:SetOperation(c65563871.recop)
	c:RegisterEffect(e2)
	--Recover by battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65563871,2))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c65563871.recon)
	e3:SetTarget(c65563871.retg)
	e3:SetOperation(c65563871.reop)
	c:RegisterEffect(e3)
end
function c65563871.mfilter(c)
	return c:IsLinkType(TYPE_NORMAL) and c:IsLinkRace(RACE_PLANT)
end
function c65563871.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0 and c:IsPreviousSetCard(0x2158) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c65563871.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65563871.cfilter,1,nil,tp)
end
function c65563871.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c65563871.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c65563871.recfilter(c)
	return c:IsSetCard(0x2158) and c:IsType(TYPE_LINK) and c:IsLinkAbove(1)
end
function c65563871.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65563871.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65563871.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c65563871.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetLink()*300)
end
function c65563871.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetLink()>0 then
		Duel.Recover(tp,tc:GetLink()*300,REASON_EFFECT)
	end
end
function c65563871.recon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsType(TYPE_LINK) and tc:IsRace(RACE_PLANT)
end
function c65563871.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function c65563871.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
