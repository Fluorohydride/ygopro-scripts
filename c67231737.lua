--リンク・バンパー
function c67231737.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERS),2,2)
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67231737,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c67231737.condition)
	e1:SetCost(c67231737.cost)
	e1:SetTarget(c67231737.target)
	e1:SetOperation(c67231737.operation)
	c:RegisterEffect(e1)
	if not c67231737.global_check then
		c67231737.global_check=true
		c67231737[0]=0
		c67231737[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c67231737.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c67231737.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c67231737.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(67231737)==0 then
		c67231737[ep]=c67231737[ep]+1
		tc:RegisterFlagEffect(67231737,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c67231737.clear(e,tp,eg,ep,ev,re,r,rp)
	c67231737[0]=0
	c67231737[1]=0
end
function c67231737.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsControler(1-tp) then return false end
	local lg=e:GetHandler():GetLinkedGroup()
	local d=a:GetBattleTarget()
	return lg and lg:IsContains(a) and d and d:IsControler(1-tp)
end
function c67231737.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local c=e:GetHandler()
	if chk==0 then return c67231737[tp]==0 or a:GetFlagEffect(67231737)~=0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c67231737.ftarget)
	e1:SetLabel(a:GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67231737.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c67231737.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c67231737.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c67231737.filter,tp,LOCATION_MZONE,0,e:GetHandler())>0 end
end
function c67231737.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=Duel.GetMatchingGroupCount(c67231737.filter,tp,LOCATION_MZONE,0,c)
	if gc==0 then return end
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() and a:IsFaceup() then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e0:SetValue(gc)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		a:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_MUST_BE_ATTACKED)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetTarget(c67231737.attg)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c67231737.attg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
