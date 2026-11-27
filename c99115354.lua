--ハイパーサイコライザー
function c99115354.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--attack limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c99115354.atktg)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c99115354.actlimit)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99115354,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,99115354)
	e3:SetCondition(c99115354.thcon)
	e3:SetTarget(c99115354.thtg)
	e3:SetOperation(c99115354.thop)
	c:RegisterEffect(e3)
end
function c99115354.atktg(e,c)
	return c:GetAttack()<e:GetHandler():GetAttack()
end
function c99115354.actlimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()>e:GetHandler():GetAttack()
end
function c99115354.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and rp==1-tp
end
function c99115354.thfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
		and Duel.IsExistingTarget(c99115354.thfilter2,tp,LOCATION_GRAVE,0,1,c,c:GetAttribute(),c:GetRace())
end
function c99115354.thfilter2(c,att,rac)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER) and c:IsAttribute(att) and c:IsRace(rac) and c:IsAbleToHand()
end
function c99115354.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c99115354.thfilter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c99115354.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c99115354.thfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),g1:GetFirst():GetAttribute(),g1:GetFirst():GetRace())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c99115354.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
