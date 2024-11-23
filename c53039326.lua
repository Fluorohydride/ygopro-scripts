--鋼核合成獣研究所
---@param c Card
function c53039326.initial_effect(c)
	aux.AddCodeList(c,36623431)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c53039326.mtcon)
	e2:SetOperation(c53039326.mtop)
	c:RegisterEffect(e2)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetDescription(aux.Stringid(53039326,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCode(EVENT_CUSTOM+53039326)
	e4:SetTarget(c53039326.target)
	e4:SetOperation(c53039326.operation)
	c:RegisterEffect(e4)
	if not c53039326.global_check then
		c53039326.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROY)
		ge1:SetOperation(c53039326.check)
		Duel.RegisterEffect(ge1,0)
	end
end
function c53039326.cfilter(c)
	return c:IsCode(36623431) and not c:IsPublic()
end
function c53039326.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c53039326.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g=Duel.GetMatchingGroup(c53039326.cfilter,tp,LOCATION_HAND,0,nil)
	local sel=1
	if g:GetCount()~=0 then
		sel=Duel.SelectOption(tp,aux.Stringid(53039326,0),aux.Stringid(53039326,1))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(53039326,1))+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local cg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
function c53039326.check(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()~=PHASE_END then return end
	local tc=eg:GetFirst()
	local turnp=Duel.GetTurnPlayer()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	while tc do
		if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:IsSetCard(0x1d) then
			if tc:GetOwner()==turnp then g1:AddCard(tc) else g2:AddCard(tc) end
		end
		tc=eg:GetNext()
	end
	if g1:GetCount()>0 then Duel.RaiseEvent(g1,EVENT_CUSTOM+53039326,re,r,rp,turnp,0) end
	if g2:GetCount()>0 then Duel.RaiseEvent(g2,EVENT_CUSTOM+53039326,re,r,rp,1-turnp,0) end
end
function c53039326.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1d) and c:IsAbleToHand()
end
function c53039326.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53039326.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53039326.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53039326.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
