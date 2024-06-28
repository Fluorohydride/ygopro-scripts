--精霊コロゾ
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcFun2(c,s.mfilter1,s.mfilter2,true)
	--special summon rule
	aux.AddContactFusionProcedure(c,s.cfilter,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_SPSUMMON)
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.natg)
	e1:SetOperation(s.naop)
	c:RegisterEffect(e1)
end
function s.mfilter1(c)
	return bit.band(c:GetOriginalType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_LINK+TYPE_XYZ)~=0
end
function s.mfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) or (c:IsLocation(LOCATION_SZONE) and bit.band(c:GetOriginalRace(),RACE_SPELLCASTER)~=0)
end
function s.cfilter(c,fc)
	return c:IsAbleToGraveAsCost() and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function s.natg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	if chkc then return chkc==a end
	if chk==0 then return a~=nil and a:IsCanBeEffectTarget(e) and a:GetAttack()>0 end
	Duel.SetTargetCard(a)
end
function s.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local preatk=c:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local aftatk=c:GetAttack()
		if preatk<aftatk and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end