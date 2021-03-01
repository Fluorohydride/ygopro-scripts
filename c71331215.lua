--War Rock Ordeal
function c71331215.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableCounterPermit(0x5a,LOCATION_SZONE)
	c:SetUniqueOnField(1,0,71331215)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c71331215.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71331215,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c71331215.drcon)
	e2:SetTarget(c71331215.drtg)
	e2:SetOperation(c71331215.drop)
	c:RegisterEffect(e2)
end
function c71331215.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x5a,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c71331215.sdcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c71331215.sdcon(e)
	return e:GetHandler():GetCounter(0x5a)==0
end
function c71331215.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local at=tc:GetBattleTarget()
	return eg:GetCount()==1 and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE)
		and at:IsRelateToBattle() and at:IsControler(tp) and at:IsSetCard(0x15f)
end
function c71331215.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5a,1,REASON_EFFECT) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71331215.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():RemoveCounter(tp,0x5a,1,REASON_EFFECT) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
