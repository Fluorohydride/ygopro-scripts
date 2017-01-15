--失楽園
function c13301895.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c13301895.immtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Indes
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c13301895.tgvalue)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,13301895)
	e4:SetCondition(c13301895.drcon)
	e4:SetTarget(c13301895.drtg)
	e4:SetOperation(c13301895.drop)
	c:RegisterEffect(e4)
end
function c13301895.immtg(e,c)
	return c:IsCode(6007213,32491822,69890967,43378048)
end
function c13301895.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c13301895.drcfilter(c)
	return c:IsFaceup() and c:IsCode(6007213,32491822,69890967,43378048)
end
function c13301895.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c13301895.drcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c13301895.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c13301895.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
