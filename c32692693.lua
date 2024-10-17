--ベアルクティ・ラディエーション
---@param c Card
function c32692693.initial_effect(c)
	c:SetUniqueOnField(1,0,32692693)
	c:EnableCounterPermit(0x60)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c32692693.target)
	c:RegisterEffect(e1)
	--special counter permit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_COUNTER_PERMIT+0x60)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c32692693.ctpermit)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32692693,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c32692693.drcon)
	e3:SetCost(c32692693.drcost)
	e3:SetTarget(c32692693.drtg)
	e3:SetOperation(c32692693.drop)
	c:RegisterEffect(e3)
	--special summon equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32692693,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetTarget(c32692693.tdtg)
	e4:SetOperation(c32692693.tdop)
	c:RegisterEffect(e4)
end
function c32692693.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x60,7,c) end
	c:AddCounter(0x60,7)
end
function c32692693.ctpermit(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsStatus(STATUS_CHAINING)
end
function c32692693.cfilter(c)
	return c:IsSetCard(0x163) and c:IsFaceup() and c:IsPreviousLocation(LOCATION_HAND+LOCATION_EXTRA)
end
function c32692693.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32692693.cfilter,1,nil)
end
function c32692693.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x60,1,REASON_COST) end
	c:RemoveCounter(tp,0x60,1,REASON_COST)
end
function c32692693.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c32692693.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c32692693.tdfilter(c)
	return c:IsSetCard(0x163) and not c:IsCode(32692693) and c:IsAbleToDeck()
end
function c32692693.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c32692693.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32692693.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c32692693.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c32692693.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
