--エクストクス・ハイドラ
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,s.mfilter,2,127,true)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(s.atktg)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--material check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.drcon)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end
function s.mfilter(c,fc)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsOnField() and c:IsControler(fc:GetControler())
end
function s.checkfilter(c,rtype)
	return c:IsType(rtype)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if #g==0 then return end
	if g:IsExists(s.checkfilter,1,nil,TYPE_FUSION) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
	if g:IsExists(s.checkfilter,1,nil,TYPE_SYNCHRO) then
		c:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if g:IsExists(s.checkfilter,1,nil,TYPE_XYZ) then
		c:RegisterFlagEffect(id+o*2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
	if g:IsExists(s.checkfilter,1,nil,TYPE_PENDULUM) then
		c:RegisterFlagEffect(id+o*3,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
	if g:IsExists(s.checkfilter,1,nil,TYPE_LINK) then
		c:RegisterFlagEffect(id+o*4,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
	end
end
function s.atktg(e,c)
	if not c:IsFaceup() then return false end
	local ec=e:GetHandler()
	local b1=ec:GetFlagEffect(id)>0 and c:IsType(TYPE_FUSION)
	local b2=ec:GetFlagEffect(id+o)>0 and c:IsType(TYPE_SYNCHRO)
	local b3=ec:GetFlagEffect(id+o*2)>0 and c:IsType(TYPE_XYZ)
	local b4=ec:GetFlagEffect(id+o*3)>0 and c:IsType(TYPE_PENDULUM)
	local b5=ec:GetFlagEffect(id+o*4)>0 and c:IsType(TYPE_LINK)
	return b1 or b2 or b3 or b4 or b5
end
function s.atkval(e,c)
	return -c:GetBaseAttack()
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and ev>=1000
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=math.floor(ev/1000)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,val) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,val)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if d>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
