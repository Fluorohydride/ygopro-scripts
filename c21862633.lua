--切り裂かれし闇
function c21862633.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21862633,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,21862633)
	e2:SetCondition(c21862633.drcon)
	e2:SetTarget(c21862633.drtg)
	e2:SetOperation(c21862633.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21862633,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,21862634)
	e4:SetCondition(c21862633.atkcon)
	e4:SetOperation(c21862633.atkop)
	c:RegisterEffect(e4)
	if not c21862633.global_check then
		c21862633.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c21862633.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c21862633.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_NORMAL) then
		c:RegisterFlagEffect(21862633,RESET_EVENT+0x4fe0000,0,1)
	end
end
function c21862633.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsSummonPlayer(tp) and not c:IsType(TYPE_TOKEN)
end
function c21862633.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21862633.cfilter,1,nil,tp)
end
function c21862633.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21862633.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c21862633.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a,at=Duel.GetBattleMonster(tp)
	return a and at and at:GetAttack()>0 and (a:IsType(TYPE_NORMAL) and a:IsLevelAbove(5)
		or a:GetFlagEffect(21862633)>0 and (a:IsSummonType(SUMMON_TYPE_RITUAL)
			or a:IsSummonType(SUMMON_TYPE_FUSION)
			or a:IsSummonType(SUMMON_TYPE_SYNCHRO)
			or a:IsSummonType(SUMMON_TYPE_XYZ)))
end
function c21862633.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a,at=Duel.GetBattleMonster(tp)
	if not a or not at or not a:IsRelateToBattle() or a:IsFacedown() or not at:IsRelateToBattle() or at:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(at:GetAttack())
	a:RegisterEffect(e1)
end
