--暗黒方界神クリムゾン・ノヴァ
function c30270176.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c30270176.spcon)
	e2:SetTarget(c30270176.sptg)
	e2:SetOperation(c30270176.spop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c30270176.immval)
	c:RegisterEffect(e3)
	--Extra Attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30270176,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c30270176.atkcon)
	e4:SetTarget(c30270176.atktg)
	e4:SetOperation(c30270176.atkop)
	c:RegisterEffect(e4)
	--Damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(30270176,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,30270176)
	e5:SetCondition(c30270176.damcon)
	e5:SetTarget(c30270176.damtg)
	e5:SetOperation(c30270176.damop)
	c:RegisterEffect(e5)
end
function c30270176.spcfilter(c)
	return c:IsSetCard(0xe3) and not c:IsPublic()
end
function c30270176.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local hg=Duel.GetMatchingGroup(c30270176.spcfilter,tp,LOCATION_HAND,0,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and hg:GetClassCount(Card.GetCode)>=3
end
function c30270176.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c30270176.spcfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,true,3,3)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c30270176.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleHand(tp)
	rg:DeleteGroup()
end
function c30270176.immval(e,te)
	if te:GetOwner()==e:GetHandler() or not te:IsActiveType(TYPE_MONSTER) or not te:IsActivated() then return false end
	local tc=te:GetOwner()
	--activated in the Monster Zone and still there face-up since: the original ATK at resolution;
	--otherwise the printed ATK ("?" is not 3000 or less)
	for i=Duel.GetCurrentChain(),1,-1 do
		local ce,loc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
		if ce==te then
			if loc==LOCATION_MZONE and tc:IsRelateToChain(i) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
				return tc:GetBaseAttack()<=3000
			end
			break
		end
	end
	return tc:GetTextAttack()>=0 and tc:GetTextAttack()<=3000
end
function c30270176.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
end
function c30270176.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK) end
end
function c30270176.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
end
function c30270176.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c30270176.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,3000)
end
function c30270176.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,3000,REASON_EFFECT,true)
	Duel.Damage(1-tp,3000,REASON_EFFECT,true)
	Duel.RDComplete()
end
