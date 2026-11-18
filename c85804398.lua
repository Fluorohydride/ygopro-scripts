--闇へ誘う太陽神
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10000010)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.damcon)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
function s.tgfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1f0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.thfilter(c)
	return c:IsSetCard(0x1ef) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.calfilter(c,p)
	return c:GetTextAttack()>0 and c:IsType(TYPE_MONSTER) and c:IsPreviousControler(p)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tg,pct,player=eg:Filter(Card.IsType,nil,TYPE_MONSTER),0,0
	local map={}
	for p in aux.TurnPlayers() do
		local dmg=0
		local dg=tg:Filter(s.calfilter,nil,p)
		if dg:GetCount()>0 then
			dmg=dg:GetSum(Card.GetTextAttack)
			pct=pct+1
			player=p
		end
		map[p]=dmg
	end
	e:SetLabel(map[tp],map[1-tp])
	if pct==2 then player=PLAYER_ALL end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,player,map[tp]+map[1-tp])
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local dmg1,dmg2=e:GetLabel()
	local map={[tp]=dmg1,[1-tp]=dmg2}
	local res=false
	for p in aux.TurnPlayers() do
		if map[p]>0 then
			local dmg=Duel.Damage(p,map[p],REASON_EFFECT,true)
			res=res or dmg>0
		end
	end
	if res then
		Duel.RDComplete()
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,10000010) then
			Duel.BreakEffect()
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
