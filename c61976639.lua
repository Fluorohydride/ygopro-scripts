--シークレット・パスフレーズ
---@param c Card
function c61976639.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,61976639+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c61976639.target)
	e1:SetOperation(c61976639.activate)
	c:RegisterEffect(e1)
end
function c61976639.thfilter(c)
	return c:IsSetCard(0x1151,0x2151) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c61976639.thfilter1(c)
	return c:IsSetCard(0x2151) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c61976639.scchk(c,sc)
	return c:IsSetCard(sc) and c:IsFaceup()
end
function c61976639.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(c61976639.thfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c61976639.thfilter1,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c61976639.scchk,tp,LOCATION_MZONE,0,1,nil,0x152)
			and Duel.IsExistingMatchingCard(c61976639.scchk,tp,LOCATION_MZONE,0,1,nil,0x153)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c61976639.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c61976639.thfilter,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(c61976639.scchk,tp,LOCATION_MZONE,0,1,nil,0x152)
		and Duel.IsExistingMatchingCard(c61976639.scchk,tp,LOCATION_MZONE,0,1,nil,0x153) then
		local eg=Duel.GetMatchingGroup(c61976639.thfilter1,tp,LOCATION_DECK,0,nil)
		g:Merge(eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
