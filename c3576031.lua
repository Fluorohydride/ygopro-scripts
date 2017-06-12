--クリスタルP
function c3576031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xea))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3576031,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c3576031.drcon)
	e4:SetTarget(c3576031.drtg)
	e4:SetOperation(c3576031.drop)
	c:RegisterEffect(e4)
	if not c3576031.global_check then
		c3576031.global_check=true
		c3576031[0]=0
		c3576031[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c3576031.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c3576031.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c3576031.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xea) and tc:IsSummonType(SUMMON_TYPE_SYNCHRO) then
			local p=tc:GetSummonPlayer()
			c3576031[p]=c3576031[p]+1
		end
		tc=eg:GetNext()
	end
end
function c3576031.clearop(e,tp,eg,ep,ev,re,r,rp)
	c3576031[0]=0
	c3576031[1]=0
end
function c3576031.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c3576031[tp]>0
end
function c3576031.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c3576031[tp]) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c3576031[tp])
end
function c3576031.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,c3576031[tp],REASON_EFFECT)
end
