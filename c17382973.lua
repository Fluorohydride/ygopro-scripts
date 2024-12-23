--プランキッズ・ドゥードゥル
---@param c Card
function c17382973.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x120),2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17382973,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,17382973)
	e1:SetCondition(c17382973.thcon)
	e1:SetTarget(c17382973.thtg)
	e1:SetOperation(c17382973.thop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17382973,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17382974)
	e2:SetCost(c17382973.thcost2)
	e2:SetTarget(c17382973.thtg2)
	e2:SetOperation(c17382973.thop2)
	c:RegisterEffect(e2)
end
function c17382973.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c17382973.thfilter(c)
	return c:IsSetCard(0x120) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c17382973.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17382973.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17382973.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17382973.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17382973.excostfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost() and c:IsHasEffect(25725326,tp)
end
function c17382973.costfilter(c,tp,g)
	local tg=g:Clone()
	tg:RemoveCard(c)
	return tg:GetClassCount(Card.GetCode)>=2
end
function c17382973.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(c17382973.excostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local tg=Duel.GetMatchingGroup(c17382973.thfilter2,tp,LOCATION_GRAVE,0,nil,e)
	if e:GetHandler():IsReleasable() then g:AddCard(e:GetHandler()) end
	if chk==0 then
		e:SetLabel(100)
		return g:IsExists(c17382973.costfilter,1,nil,tp,tg)
	end
	local cg=g:Filter(c17382973.costfilter,nil,tp,tg)
	local tc
	if #cg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25725326,0))
		tc=cg:Select(tp,1,1,nil):GetFirst()
	else
		tc=cg:GetFirst()
	end
	local te=tc:IsHasEffect(25725326,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function c17382973.thfilter2(c,e)
	return c:IsSetCard(0x120) and not c:IsType(TYPE_LINK)
		and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c17382973.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return e:GetLabel()==100 end
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(c17382973.thfilter2,tp,LOCATION_GRAVE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c17382973.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
