--獣王アルファ
---@param c Card
function c73304257.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c73304257.sprcon)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73304257,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,73304257)
	e2:SetTarget(c73304257.thtg)
	e2:SetOperation(c73304257.thop)
	c:RegisterEffect(e2)
end
function c73304257.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	return g1:GetSum(Card.GetAttack)<g2:GetSum(Card.GetAttack)
end
function c73304257.thfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsAbleToHand()
end
function c73304257.thfilter1(c,e)
	return c73304257.thfilter(c) and c:IsCanBeEffectTarget(e)
end
function c73304257.thfilter2(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c73304257.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c73304257.thfilter(chkc) end
	local ct1=Duel.GetMatchingGroupCount(c73304257.thfilter1,tp,LOCATION_MZONE,0,nil,e)
	local ct2=Duel.GetMatchingGroupCount(c73304257.thfilter2,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return ct1>0 and ct2>0 end
	local ct=math.min(ct1,ct2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c73304257.thfilter,tp,LOCATION_MZONE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c73304257.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct>0 and Duel.IsExistingMatchingCard(c73304257.thfilter2,tp,0,LOCATION_MZONE,ct,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local hg=Duel.SelectMatchingCard(tp,c73304257.thfilter2,tp,0,LOCATION_MZONE,ct,ct,nil)
			Duel.HintSelection(hg)
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,73304257))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
