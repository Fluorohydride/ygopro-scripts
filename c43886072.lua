--プランキッズ・バウワウ
---@param c Card
function c43886072.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x120),2,2)
	--atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c43886072.atktg)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43886072,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43886072)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c43886072.thcon)
	e2:SetCost(c43886072.thcost)
	e2:SetTarget(c43886072.thtg)
	e2:SetOperation(c43886072.thop)
	c:RegisterEffect(e2)
end
function c43886072.atktg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x120)
end
function c43886072.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c43886072.excostfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost() and c:IsHasEffect(25725326,tp)
end
function c43886072.costfilter(c,tp,g)
	local tg=g:Clone()
	tg:RemoveCard(c)
	return tg:GetClassCount(Card.GetCode)>=2
end
function c43886072.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(c43886072.excostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local tg=Duel.GetMatchingGroup(c43886072.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if e:GetHandler():IsReleasable() then g:AddCard(e:GetHandler()) end
	if chk==0 then
		e:SetLabel(100)
		return g:IsExists(c43886072.costfilter,1,nil,tp,tg)
	end
	local cg=g:Filter(c43886072.costfilter,nil,tp,tg)
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
function c43886072.thfilter(c,e)
	return c:IsSetCard(0x120) and not c:IsType(TYPE_LINK)
		and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c43886072.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return e:GetLabel()==100 end
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(c43886072.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function c43886072.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c43886072.indtg)
	e1:SetValue(aux.indoval)
	Duel.RegisterEffect(e1,tp)
end
function c43886072.indtg(e,c)
	return c:IsSetCard(0x120)
end
