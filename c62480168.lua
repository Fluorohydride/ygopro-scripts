--アマゾネスの秘湯
---@param c Card
function c62480168.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c62480168.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,62480168)
	e2:SetCondition(c62480168.rccon)
	e2:SetTarget(c62480168.rctg)
	e2:SetOperation(c62480168.rcop)
	c:RegisterEffect(e2)
end
function c62480168.filter(c,tp,pcon)
	return c:IsSetCard(0x4) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsType(TYPE_PENDULUM) and pcon)
end
function c62480168.activate(e,tp,eg,ep,ev,re,r,rp)
	local pcon=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g=Duel.GetMatchingGroup(c62480168.filter,tp,LOCATION_DECK,0,nil,tp,pcon)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(62480168,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc then
			local b1=sc:IsAbleToHand()
			local b2=sc:IsType(TYPE_PENDULUM) and pcon
			local s=0
			if b1 and not b2 then
				s=Duel.SelectOption(tp,aux.Stringid(62480168,1))
			end
			if not b1 and b2 then
				s=Duel.SelectOption(tp,aux.Stringid(62480168,2))+1
			end
			if b1 and b2 then
				s=Duel.SelectOption(tp,aux.Stringid(62480168,1),aux.Stringid(62480168,2))
			end
			if s==0 then
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
			if s==1 then
				Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
function c62480168.cfilter(c)
	return c:IsSetCard(0x4) and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c62480168.rccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c62480168.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c62480168.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c62480168.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
