--無死なる竜の鼓動
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.nadcon)
	e2:SetValue(s.effectfilter)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.thcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.cfilter1(c)
	return c:IsFaceup() and c:GetOriginalLevel()>=8 and c:IsSetCard(0x1f3)
end
function s.cfilter2(c)
	return c:IsFaceupEx() and c:IsRace(RACE_DRAGON)
end
function s.nadcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(s.cfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
end
function s.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x1f3) and te:IsActiveType(TYPE_MONSTER) and p==tp
end
function s.cfilter(c,tp)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (c:IsSetCard(0x1f3) or c:IsRace(RACE_DRAGON))
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetOriginalCodeRule(),c:GetOriginalLevel())
end
function s.thfilter(c,code,lv)
	return not c:IsOriginalCodeRule(code) and c:GetOriginalLevel()==lv
		and c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetOriginalCodeRule(),g:GetFirst():GetOriginalLevel())
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
