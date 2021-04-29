--サイバー・ファロス
function c29719112.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c29719112.hspcon)
	e1:SetOperation(c29719112.hspop)
	c:RegisterEffect(e1)
	--special summon
	local e2=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),
		reg=false
	})
	e2:SetDescription(aux.Stringid(29719112,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29719112,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCountLimit(1,29719112)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c29719112.thcon)
	e3:SetTarget(c29719112.thtg)
	e3:SetOperation(c29719112.thop)
	c:RegisterEffect(e3)
end
function c29719112.spfilter(c,tp)
	return c:IsRace(RACE_MACHINE)
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c29719112.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c29719112.spfilter,1,nil,tp)
end
function c29719112.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c29719112.spfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c29719112.cfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsPreviousControler(tp)
end
function c29719112.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29719112.cfilter,1,nil,tp)
end
function c29719112.thfilter(c)
	return c:IsCode(37630732) and c:IsAbleToHand()
end
function c29719112.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29719112.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29719112.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29719112.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
