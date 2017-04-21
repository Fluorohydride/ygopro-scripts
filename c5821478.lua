--トポロジック・ボマー・ドラゴン
function c5821478.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5821478,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c5821478.descon)
	e1:SetTarget(c5821478.destg)
	e1:SetOperation(c5821478.desop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5821478,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c5821478.damcon)
	e2:SetTarget(c5821478.damtg)
	e2:SetOperation(c5821478.damop)
	c:RegisterEffect(e2)
	if not Duel.GetLinkedGroup then
		function Duel.GetLinkedGroup(p,s,o)
			local g=Group.CreateGroup()
			local loc1,loc2=0,0
			if s==1 then loc1=LOCATION_MZONE end
			if o==1 then loc2=LOCATION_MZONE end
			local tg=Duel.GetMatchingGroup(c5821478.lgfilter,p,loc1,loc2,nil)
			local tc=tg:GetFirst()
			while tc do
				local lg=tc:GetLinkedGroup()
				if lg:GetCount()>0 then
					g:Merge(lg)
				end
				tc=tg:GetNext()
			end
			return g
		end
	end
end
function c5821478.lgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c5821478.cfilter(c,g)
	return g:IsContains(c)
end
function c5821478.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetLinkedGroup(tp,1,1)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c5821478.cfilter,1,nil,g)
end
function c5821478.desfilter(c)
	return c:GetSequence()<5
end
function c5821478.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c5821478.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c5821478.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c5821478.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c5821478.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c5821478.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c5821478.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()
end
function c5821478.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetAttackTarget():GetBaseAttack())
end
function c5821478.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if bc and bc:IsRelateToBattle() and bc:IsFaceup() then
		Duel.Damage(1-tp,bc:GetBaseAttack(),REASON_EFFECT)
	end
end
